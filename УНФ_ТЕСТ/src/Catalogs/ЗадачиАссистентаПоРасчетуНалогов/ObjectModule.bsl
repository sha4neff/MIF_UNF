#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Автор) Тогда
		Автор = Пользователи.АвторизованныйПользователь();
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ЭтоНовый = Ложь;
	ДополнительныеСвойства.Свойство("ЭтоНовый", ЭтоНовый);
	
	Если Не ЭтоНовый Тогда
		АссистентУправления.УдалитьЗапланированныеЗаписиЗадачи(Ссылка);
	КонецЕсли;
	
	ЗапланироватьНовыеЗадачиПоСуществующимЗаписямКалендаря();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ПередВыполнениемЗадачи(Предмет, Источник, ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	
	
	
КонецПроцедуры

Процедура ВыполнитьЗадачу(Предмет, Источник, ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	
	ОбсуждениеКалендаря = ОбсужденияУНФ.ПолучитьКонтекстноеОбсуждениеПоНавигационнойСсылке(
		"e1cib/list/Справочник.ЗаписиКалендаряПодготовкиОтчетности",
		НСтр("ru = 'Календарь налогов и отчетности'"));
	
	АдресКалендаряДляПочтовыхСообщений = НавигационнаяСсылкаНаКалендарь();
	
	Организация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Предмет, "Организация");
	
	ДатаДокументаОбработкиСобытия = КонецДня(ДополнительныеПараметры.ДатаДокументаОбработкиСобытия);
	ТекстУведомления = "";
	Если ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций") Тогда
		ТекстОрганизации = НСтр("ru = ' по организации '") + Организация;
	Иначе
		ТекстОрганизации = " ";
	КонецЕсли;
	
	ИмяФормыЗадачи = "Обработка.ОбработкиНалоговИОтчетности.Форма.ОписанияЗадачИСтартВыполнения";
	КомандыУведомления = Новый СписокЗначений;
	
	// Для налога ЕНВД заполним по умолчанию показатели на основании предыдущего периода
	Если Налог = Справочники.ЗадачиКалендаряПодготовкиОтчетности.ЕдиныйНалогЕНВД Тогда
		ПоказателиЗаполненыИзПредыдущегоПериода = Ложь;
		РегламентированнаяОтчетностьЕНВД.ЗаполнитьДокументПоказателейЕНВДНаОснованииПредыдущегоПериода(Организация,ДатаДокументаОбработкиСобытия, ПоказателиЗаполненыИзПредыдущегоПериода);
	КонецЕсли;
	
	// Выполняем проверку задачи
	РезультатПроверки = ПроверкаДанных.ВыполнитьПроверкуПоСобытию(
		Организация,
		ДополнительныеПараметры.СобытиеКалендаря);
	ТекстНалог = НСтр("ru = 'налога'");
	ТекстОсновнойКоманды = НСтр("ru = 'Перейти к задаче и оплатить'");
	ЭтоНалог = Ложь;
	Если Налог = Справочники.ЗадачиКалендаряПодготовкиОтчетности.АвансовыйПлатежПоУСН Тогда
		ТекстНалог = НСтр("ru = 'авансового платежа по УСН'");
		ЭтоНалог = Истина;
	ИначеЕсли Налог = Справочники.ЗадачиКалендаряПодготовкиОтчетности.ЕдиныйНалог Тогда
		ТекстНалог = НСтр("ru = 'единого налога по УСН'");
		ЭтоНалог = Истина;
	ИначеЕсли Налог = Справочники.ЗадачиКалендаряПодготовкиОтчетности.ЕдиныйНалогЕНВД Тогда
		ТекстНалог = НСтр("ru = 'единого налога по ЕНВД'");
		ЭтоНалог = Истина;
	ИначеЕсли Налог = Справочники.ЗадачиКалендаряПодготовкиОтчетности.СтраховыеВзносыИП Тогда
		ТекстНалог = НСтр("ru = 'фиксированных страховых взносов ИП'");
		ЭтоНалог = Истина;
	ИначеЕсли Налог = Справочники.ЗадачиКалендаряПодготовкиОтчетности.СтраховыеВзносыПриДоходахСвыше300тр Тогда
		ТекстНалог = НСтр("ru = 'страховых взносов в ПФР при доходах свыше 300 т.р.'");
		ЭтоНалог = Истина;
	ИначеЕсли Налог = Справочники.ЗадачиКалендаряПодготовкиОтчетности.НалогиСотрудников Тогда
		ТекстНалог = НСтр("ru = 'налогов с зарплаты сотрудников'");
		ЭтоНалог = Истина;
	ИначеЕсли Налог = Справочники.ЗадачиКалендаряПодготовкиОтчетности.НалогПатент Тогда
		ТекстНалог = НСтр("ru = 'патента'")+ ДополнительныеПараметры.СобытиеКалендаря.Основание;
		ЭтоНалог = Истина;
	ИначеЕсли Налог = Справочники.ЗадачиКалендаряПодготовкиОтчетности.ДекларацияПоУСН Тогда
		ТекстНалог = НСтр("ru = 'декларацию по УСН'");
	ИначеЕсли Налог = Справочники.ЗадачиКалендаряПодготовкиОтчетности.ДекларацияПоЕНВД Тогда
		ТекстНалог = НСтр("ru = 'декларацию по ЕНВД'");
	ИначеЕсли Налог = Справочники.ЗадачиКалендаряПодготовкиОтчетности.Справки2НДФЛ  Тогда
		ТекстНалог = НСтр("ru = 'справки 2-НДФЛ'");
	ИначеЕсли Налог = Справочники.ЗадачиКалендаряПодготовкиОтчетности.СреднесписочнаяЧисленность  Тогда
		ТекстНалог = НСтр("ru = 'сведения о среднесписочной численности'");
	ИначеЕсли Налог = Справочники.ЗадачиКалендаряПодготовкиОтчетности.Форма4ФСС  Тогда
		ТекстНалог = НСтр("ru = 'форму 4-ФСС'");
	ИначеЕсли Налог = Справочники.ЗадачиКалендаряПодготовкиОтчетности.Форма6НДФЛ  Тогда
		ТекстНалог = НСтр("ru = 'форму 6-НДФЛ'");
	ИначеЕсли Налог = Справочники.ЗадачиКалендаряПодготовкиОтчетности.РасчетПоСтраховымВзносам  Тогда
		ТекстНалог = НСтр("ru = 'расчет по страховым взносам'");
	ИначеЕсли Налог = Справочники.ЗадачиКалендаряПодготовкиОтчетности.СведенияОЗастрахованныхЛицах  Тогда
		ТекстНалог = НСтр("ru = 'СЗВ-М'");
	ИначеЕсли Налог = Справочники.ЗадачиКалендаряПодготовкиОтчетности.СЗВСтаж  Тогда
		ТекстНалог = НСтр("ru = 'СЗВ-СТАЖ'");
	ИначеЕсли Налог = Справочники.ЗадачиКалендаряПодготовкиОтчетности.Декларация12  Тогда
		ТекстНалог = НСтр("ru = 'декларацию №12 (розн.продажа пива и пр.)'");
	КонецЕсли;
	Если РезультатПроверки.ЕстьОшибки Тогда
		Если ЭтоНалог Тогда
			// Есть ошибки, рассчитать налог не удалось, напоминаем о сроках
			ТекстОшибок = ПолучитьТекстПервыхОшибок(РезультатПроверки.КлючПротоколаПроверки);
			ТекстУведомления = НСтр(
				"ru = 'Я хотела посчитать сумму "+ТекстНалог+" "+ТекстОрганизации+" за "
				+ ПредставлениеПериода(
					ДополнительныеПараметры.ДатаНачалаДокументов,
					КонецДня(ДополнительныеПараметры.ДатаОкончанияДокументов), "ФП=Истина")
				+ ", но не смогла."
				+ ?(ПустаяСтрока(ТекстОшибок), "Налоги,видимо, не мое. А вот у Вас все получится, я уверена. Попробуйте сами.",
				"Есть проблемы с данными:"+ТекстОшибок+"
				|Нужно исправить и повторить расчет ")+"
				|Напоминаю, что оплатить этот платеж нужно не позднее "+Формат(ДополнительныеПараметры.ДатаОкончанияСобытия,"ДЛФ=DD")+"'");
			ТекстОсновнойКоманды = НСтр("ru = 'Посмотреть ошибки в задаче и исправить'");
		Иначе
			// Есть ошибки, сформировать отчетность не удалось, напоминаем о сроках
			ТекстОшибок = ПолучитьТекстПервыхОшибок(РезультатПроверки.КлючПротоколаПроверки);
			ТекстУведомления = НСтр(
				"ru = 'Я хотела сформировать "+ТекстНалог+" "+ТекстОрганизации+" за "
				+ ПредставлениеПериода(
					ДополнительныеПараметры.ДатаНачалаДокументов,
					КонецДня(ДополнительныеПараметры.ДатаОкончанияДокументов), "ФП=Истина")
				+ ", но не смогла."
				+ ?(ПустаяСтрока(ТекстОшибок), "Отчетность,видимо, не мое. А вот у Вас все получится, я уверена. Попробуйте сами.",
				"Есть проблемы с данными:"+ТекстОшибок+"
				|Нужно исправить и повторить формирование ")+"
				|Напоминаю, что предоставить данную отчетность нужно не позднее "+Формат(ДополнительныеПараметры.ДатаОкончанияСобытия,"ДЛФ=DD")+"'");
			ТекстОсновнойКоманды = НСтр("ru = 'Посмотреть ошибки в задаче и исправить'");
		КонецЕсли;
	Иначе
		// Выполняем задачу по расчету налога
		Если Налог = Справочники.ЗадачиКалендаряПодготовкиОтчетности.АвансовыйПлатежПоУСН Тогда
			
			РегламентированнаяОтчетностьУСН.ВыполнитьФормированияВсехЗаписейКУДИР(ДатаДокументаОбработкиСобытия);
			РезультатРасчета = РегламентированнаяОтчетностьУСН.ВыполнитьРасчетАвансовогоПлатежа(Организация,ДатаДокументаОбработкиСобытия, ДополнительныеПараметры.СобытиеКалендаря);
			СуммаНалога = РезультатРасчета.ВсегоКУплатеАП;
			ИмяФормыЗадачи = "Обработка.ОбработкиНалоговИОтчетности.Форма.АвансовыйПлатежПоУСН";
			
			Если СуммаНалога = 0 Тогда
				ТекстУведомления = НСтр(
					"ru = 'Нулевая сумма "+ТекстНалог+ТекстОрганизации+" за "
					+ ПредставлениеПериода(
						ДополнительныеПараметры.ДатаНачалаДокументов,
						КонецДня(ДополнительныеПараметры.ДатаОкончанияДокументов), "ФП=Истина")
					+ ", ничего платить не нужно. Если деятельность велась, нужно проверить первичные документы и Книгу учета доходов и расходов (КУДиР).
					|На всякий случай, срок оплаты налога: "+Формат(ДополнительныеПараметры.ДатаОкончанияСобытия,"ДЛФ=DD")+"'");
				КомандыУведомления.Добавить("ПерейтиККУДиР", НСтр("ru = 'Посмотреть КУДиР'"));
				ТекстОсновнойКоманды = НСтр("ru = 'Посмотреть детали авансового платежа по УСН'");
			Иначе
				ТекстУведомления = НСтр(
					"ru = 'Посчитала сумму "+ТекстНалог+ТекстОрганизации+" за "+
					ПредставлениеПериода(
						ДополнительныеПараметры.ДатаНачалаДокументов,
						КонецДня(ДополнительныеПараметры.ДатаОкончанияДокументов), "ФП=Истина")+
					", получилось "+СуммаНалога+" руб.
					|Данную сумму нужно оплатить не позднее "+Формат(ДополнительныеПараметры.ДатаОкончанияСобытия,"ДЛФ=DD")+"'");
				ТекстОсновнойКоманды = НСтр("ru = 'Посмотреть и оплатить авансовый платеж по УСН'");
			КонецЕсли;
		ИначеЕсли Налог = Справочники.ЗадачиКалендаряПодготовкиОтчетности.ЕдиныйНалог Тогда
			
			РегламентированнаяОтчетностьУСН.ВыполнитьФормированияВсехЗаписейКУДИР(ДатаДокументаОбработкиСобытия);
			РезультатРасчета = РегламентированнаяОтчетностьУСН.ВыполнитьРасчетЕдиногоНалога(Организация,ДатаДокументаОбработкиСобытия, ДополнительныеПараметры.СобытиеКалендаря);
			СуммаНалога = РезультатРасчета.ВсегоКУплатеЕН;
			ИмяФормыЗадачи = "Обработка.ОбработкиНалоговИОтчетности.Форма.ЕдиныйНалог";
			
			Если СуммаНалога = 0 Тогда
				ТекстУведомления = НСтр(
					"ru = 'Нулевая сумма "+ТекстНалог+ТекстОрганизации+" за "
					+ ПредставлениеПериода(
						ДополнительныеПараметры.ДатаНачалаДокументов,
						КонецДня(ДополнительныеПараметры.ДатаОкончанияДокументов), "ФП=Истина")
					+ ", ничего платить не нужно. Если деятельность велась, нужно проверить первичные документы и Книгу учета доходов и расходов (КУДиР).
					|На всякий случай, срок оплаты налога: "+Формат(ДополнительныеПараметры.ДатаОкончанияСобытия,"ДЛФ=DD")+"'");
				КомандыУведомления.Добавить("ПерейтиККУДиР", НСтр("ru = 'Посмотреть КУДиР'"));
				ТекстОсновнойКоманды = НСтр("ru = 'Посмотреть детали налога по УСН'");
			Иначе
				ТекстУведомления = НСтр(
					"ru = 'Посчитала сумму "+ТекстНалог+ТекстОрганизации+" за "
					+ ПредставлениеПериода(
						ДополнительныеПараметры.ДатаНачалаДокументов,
						КонецДня(ДополнительныеПараметры.ДатаОкончанияДокументов), "ФП=Истина")
					+ ", получилось "+СуммаНалога+" руб.
					|Данную сумму нужно оплатить не позднее "+Формат(ДополнительныеПараметры.ДатаОкончанияСобытия,"ДЛФ=DD")+"'");
				ТекстОсновнойКоманды = НСтр("ru = 'Посмотреть и оплатить налог по УСН'");
			КонецЕсли;
		ИначеЕсли Налог = Справочники.ЗадачиКалендаряПодготовкиОтчетности.ЕдиныйНалогЕНВД Тогда
			РезультатРасчета = РегламентированнаяОтчетностьЕНВД.ВыполнитьРасчетЕНВД(Организация,ДатаДокументаОбработкиСобытия, ДополнительныеПараметры.СобытиеКалендаря);
			СуммаНалога = РезультатРасчета.СуммаНалога;
			ИмяФормыЗадачи = "Обработка.ОбработкиНалоговИОтчетности.Форма.ЕдиныйНалогЕНВД";
			
			Если СуммаНалога = 0 Тогда
				ТекстУведомления = НСтр(
					"ru = 'Нулевая сумма "+ТекстНалог+ТекстОрганизации+" за "
					+ ПредставлениеПериода(
						ДополнительныеПараметры.ДатаНачалаДокументов,
						КонецДня(ДополнительныеПараметры.ДатаОкончанияДокументов), "ФП=Истина")
					+ ", ничего платить не нужно. Но проверить стоит, возможно необходимо отредактировать сведения по ЕНВД.
					|На всякий случай, срок оплаты налога: "+Формат(ДополнительныеПараметры.ДатаОкончанияСобытия,"ДЛФ=DD")+"'");
				КомандыУведомления.Добавить("ПерейтиКПоказателямПоЕНВД", НСтр("ru = 'Посмотреть сведения по ЕНВД'"));
				ТекстОсновнойКоманды = НСтр("ru = 'Посмотреть детали налога по ЕНВД'");
			Иначе
				Если ПоказателиЗаполненыИзПредыдущегоПериода Тогда
					ТекстУведомления = НСтр(
						"ru = 'Посчитала сумму "+ТекстНалог+ТекстОрганизации+" за "
						+ ПредставлениеПериода(
							ДополнительныеПараметры.ДатаНачалаДокументов,
							КонецДня(ДополнительныеПараметры.ДатаОкончанияДокументов), "ФП=Истина")
						+ ", получилось "+СуммаНалога+" руб.
						|Внимание!
						|Значения физического показателя по месяцам взяла из предыдущего квартала. Если они изменились, надо пересчитать налог.
						|Данную сумму нужно оплатить не позднее "+Формат(ДополнительныеПараметры.ДатаОкончанияСобытия,"ДЛФ=DD")+"'");
					КомандыУведомления.Добавить("ПерейтиКПоказателямПоЕНВД", НСтр("ru = 'Посмотреть сведения по ЕНВД'"));
				Иначе
					ТекстУведомления = НСтр(
						"ru = 'Посчитала сумму "+ТекстНалог+ТекстОрганизации+" за "
						+ ПредставлениеПериода(
							ДополнительныеПараметры.ДатаНачалаДокументов,
							КонецДня(ДополнительныеПараметры.ДатаОкончанияДокументов), "ФП=Истина")
						+ ", получилось "+СуммаНалога+" руб.
						|Данную сумму нужно оплатить не позднее "+Формат(ДополнительныеПараметры.ДатаОкончанияСобытия,"ДЛФ=DD")+"'");
				КонецЕсли;
				ТекстОсновнойКоманды = НСтр("ru = 'Посмотреть и оплатить налог по ЕНВД'");
			КонецЕсли;
		ИначеЕсли Налог = Справочники.ЗадачиКалендаряПодготовкиОтчетности.СтраховыеВзносыИП Тогда
			
			РезультатРасчета = РегламентированнаяОтчетностьУСН.ВыполнитьРасчетВзносовВПФРиФСС(Организация,ДатаДокументаОбработкиСобытия, ДополнительныеПараметры.СобытиеКалендаря);
			СуммаНалога = РезультатРасчета.СуммаНалога;
			ИмяФормыЗадачи = "Обработка.ОбработкиНалоговИОтчетности.Форма.СтраховыеВзносыИП";
			
			Если СуммаНалога = 0 Тогда
				ТекстУведомления = НСтр(
					"ru = 'Нулевая сумма "+ТекстНалог+ТекстОрганизации+" за "
					+ ПредставлениеПериода(
						ДополнительныеПараметры.ДатаНачалаДокументов,
						КонецДня(ДополнительныеПараметры.ДатаОкончанияДокументов), "ФП=Истина")
					+ ", ничего платить не нужно, возможно взносы уже уплачены. Но проверить стоит.
					|На всякий случай, срок оплаты налога: "+Формат(ДополнительныеПараметры.ДатаОкончанияСобытия,"ДЛФ=DD")+"'");
				ТекстОсновнойКоманды = НСтр("ru = 'Посмотреть детали страховых взносов ИП'");
			Иначе
				ТекстУведомления = НСтр(
					"ru = 'Посчитала сумму "+ТекстНалог+ТекстОрганизации+" за "
					+ ПредставлениеПериода(
						ДополнительныеПараметры.ДатаНачалаДокументов,
						КонецДня(ДополнительныеПараметры.ДатаОкончанияДокументов), "ФП=Истина")
					+ ", получилось " + СуммаНалога +" руб.
					|Данную сумму нужно оплатить не позднее "+Формат(ДополнительныеПараметры.ДатаОкончанияСобытия,"ДЛФ=DD")+"'");
				ТекстОсновнойКоманды = НСтр("ru = 'Посмотреть и оплатить страховые взносы ИП'");
			КонецЕсли;
		ИначеЕсли Налог = Справочники.ЗадачиКалендаряПодготовкиОтчетности.СтраховыеВзносыПриДоходахСвыше300тр Тогда
			
			РезультатРасчета = РегламентированнаяОтчетностьУСН.ВыполнитьРасчетВзносовВПФРПриДоходахСвыше300тр(Организация,ДатаДокументаОбработкиСобытия, ДополнительныеПараметры.СобытиеКалендаря);
			СуммаНалога = Окр(РезультатРасчета.ПФРСвыше300тр, 2);
			ИмяФормыЗадачи = "Обработка.ОбработкиНалоговИОтчетности.Форма.СтраховыеВзносыПриДоходахСвыше300тр";
			
			Если СуммаНалога = 0 Тогда
				ТекстУведомления = НСтр(
					"ru = 'Нулевая сумма "+ТекстНалог+ТекстОрганизации+" за "
					+ ПредставлениеПериода(
						ДополнительныеПараметры.ДатаНачалаДокументов,
						КонецДня(ДополнительныеПараметры.ДатаОкончанияДокументов), "ФП=Истина")
					+ ", ничего платить не нужно, возможно взносы уже уплачены. Но проверить стоит.
					|На всякий случай, срок оплаты налога: "+Формат(ДополнительныеПараметры.ДатаОкончанияСобытия,"ДЛФ=DD")+"'");
				ТекстОсновнойКоманды = НСтр("ru = 'Посмотреть детали страховых взносов при доходах свыше 300 т.р.'");
			Иначе
				ТекстУведомления = НСтр(
					"ru = 'Посчитала сумму "+ТекстНалог+ТекстОрганизации+" за "
					+ ПредставлениеПериода(
						ДополнительныеПараметры.ДатаНачалаДокументов,
						КонецДня(ДополнительныеПараметры.ДатаОкончанияДокументов), "ФП=Истина")
					+ ", получилось " + СуммаНалога +" руб.
					|Данную сумму нужно оплатить не позднее "+Формат(ДополнительныеПараметры.ДатаОкончанияСобытия,"ДЛФ=DD")+"'");
				ТекстОсновнойКоманды = НСтр("ru = 'Посмотреть и оплатить страховые взносы при доходах свыше 300 т.р.'");
			КонецЕсли;
		ИначеЕсли Налог = Справочники.ЗадачиКалендаряПодготовкиОтчетности.НалогиСотрудников Тогда
			
			РезультатРасчета = РегламентированнаяОтчетностьСотрудники.ВыполнитьРасчетВзносовИНалоговПоСотрудникам(Организация,ДатаДокументаОбработкиСобытия, ДополнительныеПараметры.СобытиеКалендаря);
			СуммаНалога = РезультатРасчета.СуммаНалога;
			ИмяФормыЗадачи = "Обработка.ОбработкиНалоговИОтчетности.Форма.НалогиСотрудников";
			
			Если СуммаНалога = 0 Тогда
				БылДокументПоЗарплате = РегламентированнаяОтчетностьСотрудники.ВыполнитьПроверкуНаличияДокументаПоЗарплатеСотрудниковЗаМесяц(Организация,ДатаДокументаОбработкиСобытия);
				ТекстУведомления = НСтр(
					"ru = 'Нулевая сумма "+ТекстНалог+ТекстОрганизации+" за "
					+ ПредставлениеПериода(
						ДополнительныеПараметры.ДатаНачалаДокументов,
						КонецДня(ДополнительныеПараметры.ДатаОкончанияДокументов), "ФП=Истина")
					+ ", ничего платить не нужно."+
					?(БылДокументПоЗарплате,"Но проверить стоит.", "В программе нет документа Начисление зарплаты за " +Формат(ДатаДокументаОбработкиСобытия, "ДФ=MMMM")+"
					|Если зарплата в этот месяц начислялась, необходимо создать и соответствующий документ.")+"
					|На всякий случай, срок оплаты налога: "+Формат(ДополнительныеПараметры.ДатаОкончанияСобытия,"ДЛФ=DD")+"'");
				ТекстОсновнойКоманды = НСтр("ru = 'Посмотреть детали налогов с зарплаты'");
			Иначе
				ТекстУведомления = НСтр(
					"ru = 'Посчитала сумму "+ТекстНалог+ТекстОрганизации+" за "
					+ ПредставлениеПериода(
						ДополнительныеПараметры.ДатаНачалаДокументов,
						КонецДня(ДополнительныеПараметры.ДатаОкончанияДокументов), "ФП=Истина")
					+ ", получилось " + СуммаНалога +" руб.
					|Данную сумму нужно оплатить не позднее "+Формат(ДополнительныеПараметры.ДатаОкончанияСобытия,"ДЛФ=DD")+"'");
				ТекстОсновнойКоманды = НСтр("ru = 'Посмотреть и оплатить налоги с зарплаты'");
			КонецЕсли;
			
		ИначеЕсли Налог = Справочники.ЗадачиКалендаряПодготовкиОтчетности.НалогПатент Тогда
			
			РезультатРасчета = РегламентированнаяОтчетностьУСН.ВыполнитьРасчетНалогаПоПатенту(Организация,ДатаДокументаОбработкиСобытия, ДополнительныеПараметры.СобытиеКалендаря);
			СуммаНалога = РезультатРасчета.СуммаПатент;
			ИмяФормыЗадачи = "Обработка.ОбработкиНалоговИОтчетности.Форма.НалогПатент";
			Если СуммаНалога = 0 Тогда
				ТекстУведомления = НСтр(
					"ru = 'Нулевая сумма "+ТекстНалог+ТекстОрганизации+" за "
					+ ПредставлениеПериода(
						ДополнительныеПараметры.ДатаНачалаДокументов,
						КонецДня(ДополнительныеПараметры.ДатаОкончанияДокументов), "ФП=Истина")
					+ ", ничего платить не нужно, возможно патент уже оплачен. Но проверить стоит.
					|На всякий случай, срок оплаты налога: "+Формат(ДополнительныеПараметры.ДатаОкончанияСобытия,"ДЛФ=DD")+"'");
				ТекстОсновнойКоманды = НСтр("ru = 'Посмотреть детали платежа по патенту'");
			Иначе
				ТекстУведомления = НСтр(
					"ru = 'Посчитала сумму "+ТекстНалог+ТекстОрганизации+" за "
					+ ПредставлениеПериода(
						ДополнительныеПараметры.ДатаНачалаДокументов,
						КонецДня(ДополнительныеПараметры.ДатаОкончанияДокументов), "ФП=Истина")
					+ ", получилось " + СуммаНалога +" руб.
					|Данную сумму нужно оплатить не позднее "+Формат(ДополнительныеПараметры.ДатаОкончанияСобытия,"ДЛФ=DD")+"'");
				ТекстОсновнойКоманды = НСтр("ru = 'Посмотреть и оплатить патент'");
			КонецЕсли;
		// Формы отчетности
		ИначеЕсли Налог = Справочники.ЗадачиКалендаряПодготовкиОтчетности.ДекларацияПоУСН Тогда
			ИмяФормыЗадачи = "Обработка.ОбработкиНалоговИОтчетности.Форма.ОписанияЗадачИСтартВыполнения";
			ТекстУведомления = НСтр(
				"ru = 'Почти сформировала "+ТекстНалог+ТекстОрганизации+" за "
				+ ПредставлениеПериода(
					ДополнительныеПараметры.ДатаНачалаДокументов,
					КонецДня(ДополнительныеПараметры.ДатаОкончанияДокументов), "ФП=Истина")+".
				|До завершения формирования декларации остался один шаг.
				|Данную декларацию нужно предоставить в налоговую не позднее "+Формат(ДополнительныеПараметры.ДатаОкончанияСобытия,"ДЛФ=DD")+"'");
			ТекстОсновнойКоманды = НСтр("ru = 'Посмотреть и отправить декларацию по УСН'");
		ИначеЕсли Налог = Справочники.ЗадачиКалендаряПодготовкиОтчетности.ДекларацияПоЕНВД Тогда
			ИмяФормыЗадачи = "Обработка.ОбработкиНалоговИОтчетности.Форма.ОписанияЗадачИСтартВыполнения";
			ТекстУведомления = НСтр(
				"ru = 'Почти сформировала "+ТекстНалог+ТекстОрганизации+" за "
				+ ПредставлениеПериода(
					ДополнительныеПараметры.ДатаНачалаДокументов,
					КонецДня(ДополнительныеПараметры.ДатаОкончанияДокументов), "ФП=Истина")+".
				|До завершения формирования декларации остался один шаг.
				|Данную декларацию нужно предоставить в налоговую не позднее "+Формат(ДополнительныеПараметры.ДатаОкончанияСобытия,"ДЛФ=DD")+"'");
			ТекстОсновнойКоманды = НСтр("ru = 'Посмотреть и отправить декларацию по ЕНВД'");
		ИначеЕсли Налог = Справочники.ЗадачиКалендаряПодготовкиОтчетности.Справки2НДФЛ Тогда
			ИмяФормыЗадачи = "Обработка.ОбработкиНалоговИОтчетности.Форма.ОписанияЗадачИСтартВыполнения";
			ТекстУведомления = НСтр(
				"ru = 'Почти сформировала "+ТекстНалог+ТекстОрганизации+" за "
				+ ПредставлениеПериода(
					ДополнительныеПараметры.ДатаНачалаДокументов,
					КонецДня(ДополнительныеПараметры.ДатаОкончанияДокументов), "ФП=Истина")+".
				|До завершения формирования 2-НДФЛ остался один шаг.
				|2-НДФЛ нужно предоставить в налоговую не позднее "+Формат(ДополнительныеПараметры.ДатаОкончанияСобытия,"ДЛФ=DD")+"'");
			ТекстОсновнойКоманды = НСтр("ru = 'Посмотреть и отправить 2-НДФЛ'");
		ИначеЕсли Налог = Справочники.ЗадачиКалендаряПодготовкиОтчетности.СреднесписочнаяЧисленность Тогда
			ИмяФормыЗадачи = "Обработка.ОбработкиНалоговИОтчетности.Форма.ОписанияЗадачИСтартВыполнения";
			ТекстУведомления = НСтр(
				"ru = 'Почти сформировала "+ТекстНалог+ТекстОрганизации+" за "
				+ ПредставлениеПериода(
					ДополнительныеПараметры.ДатаНачалаДокументов,
					КонецДня(ДополнительныеПараметры.ДатаОкончанияДокументов), "ФП=Истина")+".
				|До завершения формирования среднесписочной численности остался один шаг.
				|Сведения нужно предоставить в налоговую не позднее "+Формат(ДополнительныеПараметры.ДатаОкончанияСобытия,"ДЛФ=DD")+"'");
			ТекстОсновнойКоманды = НСтр("ru = 'Посмотреть и отправить сведения о среднесписочной численности'");
		ИначеЕсли Налог = Справочники.ЗадачиКалендаряПодготовкиОтчетности.Форма4ФСС Тогда
			ИмяФормыЗадачи = "Обработка.ОбработкиНалоговИОтчетности.Форма.ОписанияЗадачИСтартВыполнения";
			ТекстУведомления = НСтр(
				"ru = 'Почти сформировала "+ТекстНалог+ТекстОрганизации+" за "
				+ ПредставлениеПериода(
					ДополнительныеПараметры.ДатаНачалаДокументов,
					КонецДня(ДополнительныеПараметры.ДатаОкончанияДокументов), "ФП=Истина")+".
				|До завершения формирования 4-ФСС остался один шаг.
				|4-ФСС нужно предоставить в ФСС не позднее "+Формат(ДополнительныеПараметры.ДатаОкончанияСобытия,"ДЛФ=DD")+"'");
			ТекстОсновнойКоманды = НСтр("ru = 'Посмотреть и отправить 4-ФСС'");
		ИначеЕсли Налог = Справочники.ЗадачиКалендаряПодготовкиОтчетности.Форма6НДФЛ Тогда
			ИмяФормыЗадачи = "Обработка.ОбработкиНалоговИОтчетности.Форма.ОписанияЗадачИСтартВыполнения";
			ТекстУведомления = НСтр(
				"ru = 'Почти сформировала "+ТекстНалог+ТекстОрганизации+" за "
				+ ПредставлениеПериода(
					ДополнительныеПараметры.ДатаНачалаДокументов,
					КонецДня(ДополнительныеПараметры.ДатаОкончанияДокументов), "ФП=Истина")+".
				|До завершения формирования 6-НДФЛ остался один шаг.
				|Форма 6-НДФЛ нужно предоставить в налоговую не позднее "+Формат(ДополнительныеПараметры.ДатаОкончанияСобытия,"ДЛФ=DD")+"'");
			ТекстОсновнойКоманды = НСтр("ru = 'Посмотреть и отправить 6-НДФЛ'");
		ИначеЕсли Налог = Справочники.ЗадачиКалендаряПодготовкиОтчетности.РасчетПоСтраховымВзносам Тогда
			ИмяФормыЗадачи = "Обработка.ОбработкиНалоговИОтчетности.Форма.ОписанияЗадачИСтартВыполнения";
			ТекстУведомления = НСтр(
				"ru = 'Почти сформировала "+ТекстНалог+ТекстОрганизации+" за "
				+ ПредставлениеПериода(
					ДополнительныеПараметры.ДатаНачалаДокументов,
					КонецДня(ДополнительныеПараметры.ДатаОкончанияДокументов), "ФП=Истина")+".
				|До завершения формирования РСВ остался один шаг.
				|Расчет по страховым взносам нужно предоставить в налоговую не позднее "+Формат(ДополнительныеПараметры.ДатаОкончанияСобытия,"ДЛФ=DD")+"'");
			ТекстОсновнойКоманды = НСтр("ru = 'Посмотреть и отправить Расчет по страховым взносам'");
		ИначеЕсли Налог = Справочники.ЗадачиКалендаряПодготовкиОтчетности.СведенияОЗастрахованныхЛицах Тогда
			ИмяФормыЗадачи = "Обработка.ОбработкиНалоговИОтчетности.Форма.ОписанияЗадачИСтартВыполнения";
			ТекстУведомления = НСтр(
				"ru = 'Почти сформировала "+ТекстНалог+ТекстОрганизации+" за "
				+ ПредставлениеПериода(
					ДополнительныеПараметры.ДатаНачалаДокументов,
					КонецДня(ДополнительныеПараметры.ДатаОкончанияДокументов), "ФП=Истина")+".
				|До завершения формирования СЗВ-М остался один шаг.
				|СЗВ-М нужно предоставить в ПФР не позднее "+Формат(ДополнительныеПараметры.ДатаОкончанияСобытия,"ДЛФ=DD")+"'");
			ТекстОсновнойКоманды = НСтр("ru = 'Посмотреть и отправить СЗВ-М'");
		ИначеЕсли Налог = Справочники.ЗадачиКалендаряПодготовкиОтчетности.СЗВСтаж Тогда
			ИмяФормыЗадачи = "Обработка.ОбработкиНалоговИОтчетности.Форма.ОписанияЗадачИСтартВыполнения";
			ТекстУведомления = НСтр(
				"ru = 'Почти сформировала "+ТекстНалог+ТекстОрганизации+" за "
				+ ПредставлениеПериода(
					ДополнительныеПараметры.ДатаНачалаДокументов,
					КонецДня(ДополнительныеПараметры.ДатаОкончанияДокументов), "ФП=Истина")+".
				|До завершения формирования СЗВ-СТАЖ остался один шаг.
				|СЗВ-СТАЖ нужно предоставить в ПФР не позднее "+Формат(ДополнительныеПараметры.ДатаОкончанияСобытия,"ДЛФ=DD")+"'");
			ТекстОсновнойКоманды = НСтр("ru = 'Посмотреть и отправить СЗВ-СТАЖ'");
		ИначеЕсли Налог = Справочники.ЗадачиКалендаряПодготовкиОтчетности.Декларация12 Тогда
			ИмяФормыЗадачи = "Обработка.ОбработкиНалоговИОтчетности.Форма.ОписанияЗадачИСтартВыполнения";
			ТекстУведомления = НСтр(
				"ru = 'Почти сформировала "+ТекстНалог+ТекстОрганизации+" за "
				+ ПредставлениеПериода(
					ДополнительныеПараметры.ДатаНачалаДокументов,
					КонецДня(ДополнительныеПараметры.ДатаОкончанияДокументов), "ФП=Истина")+".
				|До завершения формирования Декларации №12 остался один шаг.
				|Декларацию №12 нужно предоставить в ФСРАР не позднее "+Формат(ДополнительныеПараметры.ДатаОкончанияСобытия,"ДЛФ=DD")+"'");
			ТекстОсновнойКоманды = НСтр("ru = 'Посмотреть и отправить декларацию №12'");
		КонецЕсли;
		
	КонецЕсли;
	
	// Отправляем уведомления пользователю
	Если СпособОповещения = Перечисления.СпособОповещенияАссистентаУправления.СообщениеКонтекстногоОбсужденияПользователю Тогда
		КомандыУведомления.Добавить("ПерейтиКЗадачеПоНалогам", ТекстОсновнойКоманды);
		ДанныеСообщения = ОбсужденияУНФ.НовыйДанныеСообщения();
		ДанныеСообщения.Объект = ОбсуждениеКалендаря.Идентификатор;
		ДанныеСообщения.Действия = КомандыУведомления;
		ДанныеСообщения.Данные = Новый Структура("ИмяФормыЗадачи, ПараметрыОткрытия", ИмяФормыЗадачи,
			Новый Структура("СобытиеКалендаря, СостояниеСобытия, Организация,ПоказыватьДанныеПоследнейПроверки, ФормироватьПриОткрытии",
				ДополнительныеПараметры.СобытиеКалендаря,
				Перечисления.СостоянияСобытийКалендаря.Ознакомиться,
				Организация,
				Истина,
				НЕ ЭтоНалог));
		ДанныеСообщения.Текст = ТекстУведомления;
		ДанныеСообщения.Дата = МестноеВремя(ТекущаяУниверсальнаяДата(), РаботаВМоделиСервиса.ПолучитьЧасовойПоясОбластиДанных(РаботаВМоделиСервиса.ЗначениеРазделителяСеанса()));
		ДанныеСообщения.Автор = АссистентУправления.ПользовательАссистент();
		ДанныеСообщения.Получатель = ПользовательДляОповещения;
		ОбсужденияУНФ.СоздатьСообщение(ДанныеСообщения);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПочтаДляОповещения) Тогда
		ТемаПисьма = НСтр("ru = 'Новое уведомление: срок оплаты "+ТекстНалог+":"+Формат(ДополнительныеПараметры.ДатаОкончанияСобытия,"ДЛФ=DD")+"'");
		ТекстУведомления = ТекстУведомления + ?(ПустаяСтрока(АдресКалендаряДляПочтовыхСообщений),"","
		|Перейти в календарь: "+АдресКалендаряДляПочтовыхСообщений);
		РаботаСПочтовымиСообщениями.ОтправитьПочтовоеСообщение(Справочники.УчетныеЗаписиЭлектроннойПочты.СистемнаяУчетнаяЗаписьЭлектроннойПочты,
			Новый Структура("Кому,Тема,Тело",
				ПочтаДляОповещения, ТемаПисьма, ТекстУведомления));
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПослеВыполненияЗадачи(Предмет, Источник, ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗапланироватьНовыеЗадачиПоСуществующимЗаписямКалендаря()
	
	НовыеЗадачиКВыполнению = АссистентУправления.НовыйТаблицаРегулярныхЗадачКВыполнению();
	Справочники.ЗадачиАссистентаПоРасчетуНалогов.ЗапланироватьЗадачиКВыполнению(
		НовыеЗадачиКВыполнению, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Ссылка));
	Если НовыеЗадачиКВыполнению.Количество() <> 0 Тогда
		АссистентУправления.ЗапланироватьВыполнениеРегулярныхЗадач(НовыеЗадачиКВыполнению);
	КонецЕсли;
	
КонецПроцедуры

Функция НавигационнаяСсылкаНаКалендарь()
	
	НавигационнаяСсылкаИнформационнойБазы = ПолучитьНавигационнуюСсылкуИнформационнойБазы();
	БазаОпубликованаНаВебСервере = СтрНачинаетсяС(НавигационнаяСсылкаИнформационнойБазы, "http://") ИЛИ СтрНачинаетсяС(НавигационнаяСсылкаИнформационнойБазы, "https://");
	
	Если Не БазаОпубликованаНаВебСервере Тогда
		Возврат "";
	КонецЕсли;
	
	НавигационнаяСсылкаНаКалендарь = "/#e1cib/list/Справочник.ЗаписиКалендаряПодготовкиОтчетности";
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		ОбластьДанных = "/" + Формат(РаботаВМоделиСервиса.ЗначениеРазделителяСеанса(), "ЧГ=0");
	Иначе
		ОбластьДанных = "";
	КонецЕсли;
	
	Возврат НавигационнаяСсылкаИнформационнойБазы + ОбластьДанных + НавигационнаяСсылкаНаКалендарь;
	
КонецФункции

Функция ПолучитьТекстПервыхОшибок(КлючПоследнегоПротокола)
	
	
	МенеджерЗаписи = РегистрыСведений.ПротоколыПроверкиДанных.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(МенеджерЗаписи, КлючПоследнегоПротокола);
	МенеджерЗаписи.Прочитать();
	
	ТекстОшибок = "";
	
	Если НЕ МенеджерЗаписи.Выбран() Тогда
		Возврат ТекстОшибок;
	КонецЕсли;
	
	ДеревоРезультат = МенеджерЗаписи.Протокол.Получить();
	
	
	ВременныйМассивРасшифровок = Новый Массив;
	
	КоличествоНайденных = 0;
	
	
	Для Каждого СтрВерхнийУровень Из ДеревоРезультат.Строки Цикл
		
		// Если верхний уровень проверки ОК, значит и подчиненные ок
		Если СтрВерхнийУровень.РезультатКонтроля = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		// Более 4х ошибок не показываем
		Если КоличествоНайденных > 4 Тогда
			Прервать;
		КонецЕсли;
		
		// Проверим ошибки и предупреждения
		Для Каждого СтрНижнийУровень Из СтрВерхнийУровень.Строки Цикл
			
			Если СтрНижнийУровень.РезультатКонтроля = 0 Тогда
				Продолжить;
			КонецЕсли;
			КоличествоНайденных = КоличествоНайденных + 1;
			
			// Более 4х ошибок не показываем
			Если КоличествоНайденных > 4 Тогда
				Прервать;
			КонецЕсли;
			
			ТекстОшибок = ТекстОшибок + "
			|"+ СтрВерхнийУровень.Описание+": " + СтрНижнийУровень.Описание;
			
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат ТекстОшибок;
	
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли