#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает Истина, если есть включенные задачи по напоминаниям о записи
Функция ЕстьЗадачиВРаботе() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЗадачиАссистентаПоНапоминаниямОЗаписи.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ЗадачиАссистентаПоНапоминаниямОЗаписи КАК ЗадачиАссистентаПоНапоминаниямОЗаписи
	|ГДЕ
	|	НЕ ЗадачиАссистентаПоНапоминаниямОЗаписи.ПометкаУдаления
	|	И ЗадачиАссистентаПоНапоминаниямОЗаписи.Используется";
	
	Результат = Запрос.Выполнить();
	Возврат НЕ Результат.Пустой();
	
КонецФункции

#Область ДляВызоваИзДругихПодсистем

// См. ШаблоныСообщенийПереопределяемый.ПриПодготовкеШаблонаСообщения.
Процедура ПриПодготовкеШаблонаСообщения(Реквизиты, Вложения, НазначениеШаблона, ДополнительныеПараметры) Экспорт 
	
	Если ДополнительныеПараметры.ТипШаблона <> "Письмо" Тогда
		Возврат;
	КонецЕсли;
	
	Если НазначенияШаблоновСКнопкойОтменаЗаписи().Найти(НазначениеШаблона) = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НовыйРеквизит = Реквизиты.Добавить();
	НовыйРеквизит.Имя = "КнопкаОтменитьЗапись";
	НовыйРеквизит.Представление = НСтр("ru = 'Кнопка ""Отменить запись""'");
	
	Если ДополнительныеПараметры.ФорматПисьма = Перечисления.СпособыРедактированияЭлектронныхПисем.HTML Тогда
		КартинкаКнопки = Вложения.Добавить();
		КартинкаКнопки.Идентификатор = "КартинкаКнопкиДляОтменыЗаписи";
		КартинкаКнопки.Имя = "КартинкаКнопкиДляОтменыЗаписи";
		КартинкаКнопки.Представление = НСтр("ru = 'Кнопка ""Отменить запись""'");
		КартинкаКнопки.ТипФайла = "png";
		КартинкаКнопки.Реквизит = "КнопкаОтменитьЗапись";
	КонецЕсли;
	
КонецПроцедуры

// См. ШаблоныСообщенийПереопределяемый.ПриФормированииСообщения.
Процедура ПриФормированииСообщения(Сообщение, НазначениеШаблона, ПредметСообщения, ПараметрыШаблона) Экспорт
	
	Если ПараметрыШаблона.ТипШаблона <> "Письмо" Тогда
		Возврат;
	КонецЕсли;
	
	Если НазначенияШаблоновСКнопкойОтменаЗаписи().Найти(НазначениеШаблона) = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Сообщение.ЗначенияРеквизитов.Получить("КнопкаОтменитьЗапись") = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ШаблонСсылкаДляОтмены = "mailto:[АдресЭлектроннойПочты]?subject=[ТемаПисьма]&body=[ТелоПисьма]";
	
	ПараметрыСтроки = Новый Структура;
	ПараметрыСтроки.Вставить("АдресЭлектроннойПочты", АдресЭлектроннойПочтыДляОтменыЗаписи());
	ПараметрыСтроки.Вставить("ТемаПисьма", НовыйТемаПисьмаОтменаЗаписьПоПредмету(НазначениеШаблона, ПредметСообщения));
	ПараметрыСтроки.Вставить("ТелоПисьма", ТелоПисьмаОтменаЗапись());
	СсылкаДляОтмены = СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(ШаблонСсылкаДляОтмены, ПараметрыСтроки);
	
	Если ПараметрыШаблона.ФорматПисьма = Перечисления.СпособыРедактированияЭлектронныхПисем.HTML Тогда
		Если Сообщение.Вложения.Получить("КнопкаОтменитьЗапись") = Неопределено Тогда
			Сообщение.Вложения.Вставить("КнопкаОтменитьЗапись", ПоместитьВоВременноеХранилище(КартинкаКнопкаОтменитьЗаписьПоУмолчанию()));
		КонецЕсли;
		ЗначениеКнопкаОтменитьЗапись = СтрШаблон("<a href=""%1""><img src=""cid:КнопкаОтменитьЗапись""></a>", СсылкаДляОтмены);
	Иначе
		ЗначениеКнопкаОтменитьЗапись = НСтр("ru='Отменить запись:'") + Символы.ПС + СсылкаДляОтмены;
	КонецЕсли;
	
	Сообщение.ЗначенияРеквизитов.Вставить("КнопкаОтменитьЗапись", ЗначениеКнопкаОтменитьЗапись);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ПередНачаломВыполненияЗадач(НовыеЗадачиКВыполнению) Экспорт
	
	
	
КонецПроцедуры

Процедура ПередЗаписьюПредметаЗадачи(ПредметОбъект) Экспорт
	
	ПредметОбъект.ДополнительныеСвойства.Вставить("ЗадачиАссистента", Новый Структура);
	ПредметОбъект.ДополнительныеСвойства.ЗадачиАссистента.Вставить("ЭтоНовый", ПредметОбъект.ЭтоНовый());
	
	ПередЗаписьюЗаказаПокупателя(ПредметОбъект);
	ПередЗаписьюСобытиеЗапись(ПредметОбъект);
	
КонецПроцедуры

Процедура ПриЗаписиПредметаЗадачи(ПредметОбъект) Экспорт
	
	НовыеРегулярныеЗадачиКВыполнению = АссистентУправления.НовыйТаблицаРегулярныхЗадачКВыполнению();
	НовыеТекущиеЗадачиКВыполнению = АссистентУправления.НовыйТаблицаТекущихЗадачКВыполнению();
	
	ПриЗаписиДокументаСобытиеЗапись(ПредметОбъект, НовыеТекущиеЗадачиКВыполнению, НовыеРегулярныеЗадачиКВыполнению);
	ПриЗаписиДокументаСобытиеПисьмо(ПредметОбъект);
	
	Если НовыеРегулярныеЗадачиКВыполнению.Количество() <> 0 Тогда
		АссистентУправления.ЗапланироватьВыполнениеРегулярныхЗадач(НовыеРегулярныеЗадачиКВыполнению);
	КонецЕсли;
	
	Если НовыеТекущиеЗадачиКВыполнению.Количество() <> 0 Тогда
		АссистентУправления.ДобавитьТекущиеЗадачиКВыполнению(НовыеТекущиеЗадачиКВыполнению);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведенияПредметаЗадачи(ПредметОбъект) Экспорт
	
	НовыеРегулярныеЗадачиКВыполнению = АссистентУправления.НовыйТаблицаРегулярныхЗадачКВыполнению();
	НовыеТекущиеЗадачиКВыполнению = АссистентУправления.НовыйТаблицаТекущихЗадачКВыполнению();
	
	ОбработкаПроведенияДокументаЗаказНарядЗапись(ПредметОбъект, НовыеТекущиеЗадачиКВыполнению, НовыеРегулярныеЗадачиКВыполнению);
	
	Если НовыеРегулярныеЗадачиКВыполнению.Количество() <> 0 Тогда
		АссистентУправления.ЗапланироватьВыполнениеРегулярныхЗадач(НовыеРегулярныеЗадачиКВыполнению);
	КонецЕсли;
	
	Если НовыеТекущиеЗадачиКВыполнению.Количество() <> 0 Тогда
		АссистентУправления.ДобавитьТекущиеЗадачиКВыполнению(НовыеТекущиеЗадачиКВыполнению);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведенияПредметаЗадачи(ПредметОбъект) Экспорт
	
	ЗадачиАссистента = ВыборкаЗадачКВыполнению();
	УдалитьЗапланированныеЗадачиПоПредмету(ПредметОбъект.Ссылка, ЗадачиАссистента);
	
КонецПроцедуры

Процедура ЗапланироватьЗадачиКВыполнению(НовыеРегулярныеЗадачиКВыполнению, ВыбранныеЗадачиАссистента = Неопределено, ВыбранныеЗаписиКалендаря = Неопределено) Экспорт
	
	
	
КонецПроцедуры

Функция ИдентификаторЗадачаНапоминаниеОЗаписи() Экспорт
	
	Возврат "НапоминаниеОЗаписи";
	
КонецФункции

Функция ИдентификаторЗадачаПодтверждениеЗаписи() Экспорт
	
	Возврат "ПодтверждениеЗаписи";
	
КонецФункции

Функция ИдентификаторЗадачаПодтверждениеОтменыЗаписи() Экспорт
	
	Возврат "ПодтверждениеОтменыЗаписи";
	
КонецФункции

Функция ИдентификаторЗадачаПроведениеОпросаПослеЗаписи() Экспорт
	
	Возврат "ПроведениеОпросаПослеЗаписи";
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ВыборкаЗадачКВыполнению()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗадачиАссистентаПоНапоминаниямОЗаписи.Ссылка КАК Ссылка,
	|	ЗадачиАссистентаПоНапоминаниямОЗаписи.Идентификатор КАК Идентификатор,
	|	ЗадачиАссистентаПоНапоминаниямОЗаписи.ДляВидаЗаказНаряда КАК ДляВидаЗаказНаряда,
	|	ЗадачиАссистентаПоНапоминаниямОЗаписи.ДляДокументаСобытие КАК ДляДокументаСобытие,
	|	ЗадачиАссистентаПоНапоминаниямОЗаписи.Используется КАК Используется,
	|	ЗадачиАссистентаПоНапоминаниямОЗаписи.НеОтправлятьСообщенияПосле КАК НеОтправлятьСообщенияПосле,
	|	ЗадачиАссистентаПоНапоминаниямОЗаписи.ОповеститьСразу КАК ОповеститьСразу,
	|	ЗадачиАссистентаПоНапоминаниямОЗаписи.ОповещатьДоСобытия КАК ОповещатьДоСобытия,
	|	ЗадачиАссистентаПоНапоминаниямОЗаписи.ОтборСостояниеПредмета КАК ОтборСостояниеПредмета,
	|	ЗадачиАссистентаПоНапоминаниямОЗаписи.ОтменятьОснованиеЗапись КАК ОтменятьОснованиеЗапись,
	|	ЗадачиАссистентаПоНапоминаниямОЗаписи.ОтправлятьСообщенияС КАК ОтправлятьСообщенияС,
	|	ЗадачиАссистентаПоНапоминаниямОЗаписи.УчетнаяЗапись КАК УчетнаяЗапись,
	|	ЗадачиАссистентаПоНапоминаниямОЗаписи.ЧасовДоСобытия КАК ЧасовДоСобытия,
	|	ЗадачиАссистентаПоНапоминаниямОЗаписи.ШаблонСообщения КАК ШаблонСообщения
	|ИЗ
	|	Справочник.ЗадачиАссистентаПоНапоминаниямОЗаписи КАК ЗадачиАссистентаПоНапоминаниямОЗаписи
	|ГДЕ
	|	ЗадачиАссистентаПоНапоминаниямОЗаписи.Используется
	|	И НЕ ЗадачиАссистентаПоНапоминаниямОЗаписи.ПометкаУдаления";
	
	Результат = Запрос.Выполнить().Выбрать();
	Возврат Результат;
	
КонецФункции

Функция СекундОтЗадачи(ДанныеЗадачи)
	
	СекундВЧасе = 3600;
	ЧасовОтЗадачиВСекундах = ДанныеЗадачи.ЧасовДоСобытия * СекундВЧасе;
	Если ДанныеЗадачи.ОповещатьДоСобытия Тогда
		ЧасовОтЗадачиВСекундах = ЧасовОтЗадачиВСекундах * -1;
	КонецЕсли;
	
	Возврат ЧасовОтЗадачиВСекундах;
	
КонецФункции

Функция ПлановаяДатаСУчетомОграниченияПоВремени(ЗадачаАссистента, Знач ПлановаяДата)
	
	Если НЕ ЗначениеЗаполнено(ЗадачаАссистента.ОтправлятьСообщенияС)
		И НЕ ЗначениеЗаполнено(ЗадачаАссистента.НеОтправлятьСообщенияПосле) Тогда
		Возврат ПлановаяДата;
	КонецЕсли;
	
	ВыбранноеВремяДня = Дата(1,1,1) + (ПлановаяДата - НачалоДня(ПлановаяДата));
	
	Если ВыбранноеВремяДня >= ЗадачаАссистента.ОтправлятьСообщенияС
		И ВыбранноеВремяДня <= ЗадачаАссистента.НеОтправлятьСообщенияПосле Тогда
		Возврат ПлановаяДата;
	КонецЕсли;
	
	Если ЗадачаАссистента.ОповещатьДоСобытия Тогда
		НовоеВремяДняВСекундах = ЗадачаАссистента.ОтправлятьСообщенияС - Дата(1,1,1);
	Иначе
		СекундВСутках = 86400;
		НовоеВремяДняВСекундах = ЗадачаАссистента.ОтправлятьСообщенияС - Дата(1,1,1);
		НовоеВремяДняВСекундах = НовоеВремяДняВСекундах+ СекундВСутках;
	КонецЕсли;
	
	Возврат НачалоДня(ПлановаяДата) + НовоеВремяДняВСекундах;
	
КонецФункции

Функция ПредметПодходитУсловиямЗадачи(ЗадачаАссистента, ПредметОбъект)
	
	Если ТипЗнч(ПредметОбъект) = Тип("ДокументОбъект.ЗаказПокупателя") Тогда
		Возврат ЗаказПокупателяПодходитУсловиямЗадачи(ЗадачаАссистента, ПредметОбъект);
	КонецЕсли;
	
	Если ТипЗнч(ПредметОбъект) = Тип("ДокументОбъект.Событие") Тогда
		Возврат СобытиеПодходитУсловиямЗадачи(ЗадачаАссистента, ПредметОбъект);
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

Процедура ЗапланироватьЗадачиНапоминанияОЗаписи(ПредметОбъект, ТаблицаРесурсыПредприятия, ЗадачиАссистента, НовыеРегулярныеЗадачиКВыполнению)
	
	Если ТаблицаРесурсыПредприятия.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекущаяДатаСеанса = ТекущаяДатаСеанса();
	
	Пока ЗадачиАссистента.Следующий() Цикл
		
		Если ЗадачиАссистента.Идентификатор <> Справочники.ЗадачиАссистентаПоНапоминаниямОЗаписи.ИдентификаторЗадачаНапоминаниеОЗаписи() Тогда
			Продолжить;
		КонецЕсли;
		
		Если НЕ ПредметПодходитУсловиямЗадачи(ЗадачиАссистента, ПредметОбъект) Тогда
			Продолжить;
		КонецЕсли;
		
		Для каждого ВыбранныйРесурс Из ТаблицаРесурсыПредприятия Цикл
			ПлановаяДата = ВыбранныйРесурс.Старт;
			НеВыполнятьПосле = ВыбранныйРесурс.Старт;
			ДеньНапоминанияПоРесурсам = ВыбранныйРесурс.Старт;
			
			ПлановаяДата = ПлановаяДата + СекундОтЗадачи(ЗадачиАссистента);
			ПлановаяДата = ПлановаяДатаСУчетомОграниченияПоВремени(ЗадачиАссистента, ПлановаяДата);
			
			Если ТекущаяДатаСеанса > ПлановаяДата Тогда
				Продолжить;
			КонецЕсли;
			
			ДополнительныеПараметры = Новый Структура;
			ДополнительныеПараметры.Вставить("ДеньНапоминанияПоРесурсам", ДеньНапоминанияПоРесурсам);
			
			НоваяЗадачаПлан = НовыеРегулярныеЗадачиКВыполнению.Добавить();
			НоваяЗадачаПлан.Дата = ПлановаяДата;
			НоваяЗадачаПлан.Предмет = ПредметОбъект.Ссылка;
			НоваяЗадачаПлан.Задача = ЗадачиАссистента.Ссылка;
			НоваяЗадачаПлан.НеВыполнятьПосле = НеВыполнятьПосле;
			НоваяЗадачаПлан.ДополнительныеПараметры = ДополнительныеПараметры;
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗапланироватьЗадачиОпросаПослеЗаписи(ПредметОбъект, ИнтервалЗаписи, ЗадачиАссистента, НовыеРегулярныеЗадачиКВыполнению)
	
	Если ИнтервалЗаписи = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущаяДатаСеанса = ТекущаяДатаСеанса();
	
	Пока ЗадачиАссистента.Следующий() Цикл
		Если ЗадачиАссистента.Идентификатор <> Справочники.ЗадачиАссистентаПоНапоминаниямОЗаписи.ИдентификаторЗадачаПроведениеОпросаПослеЗаписи() Тогда
			Продолжить;
		КонецЕсли;
		
		Если НЕ ПредметПодходитУсловиямЗадачи(ЗадачиАссистента, ПредметОбъект) Тогда
			Продолжить;
		КонецЕсли;
		
		ПлановаяДата = ИнтервалЗаписи.ОкончаниеИнтервала;
		ПлановаяДата = ПлановаяДата + СекундОтЗадачи(ЗадачиАссистента);
		ПлановаяДата = ПлановаяДатаСУчетомОграниченияПоВремени(ЗадачиАссистента, ПлановаяДата);
		
		НоваяЗадачаПлан = НовыеРегулярныеЗадачиКВыполнению.Добавить();
		НоваяЗадачаПлан.Дата = ПлановаяДата;
		НоваяЗадачаПлан.Предмет = ПредметОбъект.Ссылка;
		НоваяЗадачаПлан.Задача = ЗадачиАссистента.Ссылка;
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗапланироватьЗадачиПодтверждения(ПредметОбъект, ИнтервалЗаписи, ЗадачиАссистента, НовыеТекущиеЗадачиКВыполнению)
	
	Пока ЗадачиАссистента.Следующий() Цикл
		Если ЗадачиАссистента.Идентификатор <> Справочники.ЗадачиАссистентаПоНапоминаниямОЗаписи.ИдентификаторЗадачаПодтверждениеЗаписи()
			И ЗадачиАссистента.Идентификатор <> Справочники.ЗадачиАссистентаПоНапоминаниямОЗаписи.ИдентификаторЗадачаПодтверждениеОтменыЗаписи() Тогда
			Продолжить;
		КонецЕсли;
		
		Если НЕ ПредметПодходитУсловиямЗадачи(ЗадачиАссистента, ПредметОбъект) Тогда
			Продолжить;
		КонецЕсли;
		
		Если ЗадачиАссистента.Идентификатор = Справочники.ЗадачиАссистентаПоНапоминаниямОЗаписи.ИдентификаторЗадачаПодтверждениеЗаписи()
			И НЕ (ЭтоНовыйПредмет(ПредметОбъект) ИЛИ ИзменилосьПроведениеЗаказа(ПредметОбъект) ИЛИ ИзмениласьТаблицаРесурсов(ПредметОбъект)) Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяЗадачаПлан = НовыеТекущиеЗадачиКВыполнению.Добавить();
		НоваяЗадачаПлан.Предмет = ПредметОбъект.Ссылка;
		НоваяЗадачаПлан.Задача = ЗадачиАссистента.Ссылка;
	КонецЦикла;
	
КонецПроцедуры

Процедура УдалитьЗапланированныеЗадачиПоПредмету(Предмет, ЗадачиАссистента)
	
	УдаляемыеЗадачи = Новый Массив;
	
	Пока ЗадачиАссистента.Следующий() Цикл
		УдаляемыеЗадачи.Добавить(ЗадачиАссистента.Ссылка);
	КонецЦикла;
	
	АссистентУправления.УдалитьЗапланированныеЗаписиПоПредмету(Предмет.Ссылка, УдаляемыеЗадачи);
	
КонецПроцедуры

Функция ЭтоНовыйПредмет(ПредметОбъект)
	
	Возврат ПредметОбъект.ДополнительныеСвойства.ЗадачиАссистента.ЭтоНовый;
	
КонецФункции

Функция ИзмениласьТаблицаРесурсов(ПредметОбъект)
	
	РесурсыПредприятияДоЗаписи = ПредметОбъект.ДополнительныеСвойства.ЗадачиАссистента.ДанныеДоЗаписи.РесурсыПредприятия;
	Если РесурсыПредприятияДоЗаписи = Неопределено Тогда
		КоличествоРесурсовДоЗаписи = 0;
		КоличествоРесурсовСейчас = ПредметОбъект.РесурсыПредприятия.Количество();
		Возврат КоличествоРесурсовДоЗаписи = КоличествоРесурсовСейчас;
	КонецЕсли;
	
	Возврат НЕ ОбщегоНазначения.КоллекцииИдентичны(
		ПредметОбъект.РесурсыПредприятия.Выгрузить(),
		РесурсыПредприятияДоЗаписи.Выгрузить());
	
КонецФункции

Функция ИзмениласьПометкаУдаления(ПредметОбъект)
	
	Возврат ПредметОбъект.ПометкаУдаления <> ПредметОбъект.ДополнительныеСвойства.ЗадачиАссистента.ДанныеДоЗаписи.ПометкаУдаления;
	
КонецФункции

Функция ЕстьИзмененияПоПредмету(ПредметОбъект)
	
	Если ТипЗнч(ПредметОбъект) = Тип("ДокументОбъект.ЗаказПокупателя") Тогда
		Возврат ИзмениласьТаблицаРесурсов(ПредметОбъект)
			ИЛИ ИзменилосьСостояниеЗаказа(ПредметОбъект)
			ИЛИ ИзменилсяВидЗаказа(ПредметОбъект)
			ИЛИ ИзменилосьПроведениеЗаказа(ПредметОбъект);
	ИначеЕсли ТипЗнч(ПредметОбъект) = Тип("ДокументОбъект.Событие") Тогда
		Возврат ИзмениласьТаблицаРесурсов(ПредметОбъект)
			ИЛИ ИзменилосьСостояниеСобытия(ПредметОбъект)
			ИЛИ ИзмениласьПометкаУдаления(ПредметОбъект);
	КонецЕсли;
	
КонецФункции

#Область ОбработкаЗаказаПокупателя

Процедура ПередЗаписьюЗаказаПокупателя(ПредметОбъект)
	
	Если ТипЗнч(ПредметОбъект) <> Тип("ДокументОбъект.ЗаказПокупателя") Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ПредметОбъект.ЭтоЗаказНаряд() Тогда
		Возврат;
	КонецЕсли;
	
	РеквизитыЗаказа = "ВариантЗавершения,ВидЗаказа,ПометкаУдаления,СостояниеЗаказа,РесурсыПредприятия";
	ДанныеСсылки = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ПредметОбъект.Ссылка, РеквизитыЗаказа);
	
	ПредметОбъект.ДополнительныеСвойства.ЗадачиАссистента.Вставить("Проведен", ПредметОбъект.Проведен);
	ПредметОбъект.ДополнительныеСвойства.ЗадачиАссистента.Вставить("ДанныеДоЗаписи", ДанныеСсылки);
	
КонецПроцедуры

Процедура ОбработкаПроведенияДокументаЗаказНарядЗапись(ПредметОбъект, НовыеТекущиеЗадачиКВыполнению, НовыеРегулярныеЗадачиКВыполнению)
	
	Если ТипЗнч(ПредметОбъект) <> Тип("ДокументОбъект.ЗаказПокупателя") Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ПредметОбъект.ЭтоЗаказНаряд() Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаРесурсыПредприятия = Неопределено;
	ПредметОбъект.ДополнительныеСвойства.ТаблицыДляДвижений.Свойство("ТаблицаРесурсыПредприятия", ТаблицаРесурсыПредприятия);
	
	Если ТаблицаРесурсыПредприятия = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЕстьИзмененияПоПредмету(ПредметОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ИнтервалЗаписи = ПланированиеРесурсовУНФ.МаксимальныеГраницыИнтервала(ТаблицаРесурсыПредприятия, "Старт", "Финиш");
	ЗадачиАссистента = ВыборкаЗадачКВыполнению();
	
	УдалитьЗапланированныеЗадачиПоПредмету(ПредметОбъект.Ссылка, ЗадачиАссистента);
	ЗадачиАссистента.Сбросить();
	
	ЗапланироватьЗадачиНапоминанияОЗаписи(ПредметОбъект, ТаблицаРесурсыПредприятия, ЗадачиАссистента, НовыеРегулярныеЗадачиКВыполнению);
	ЗадачиАссистента.Сбросить();
	
	ЗапланироватьЗадачиОпросаПослеЗаписи(ПредметОбъект, ИнтервалЗаписи, ЗадачиАссистента, НовыеРегулярныеЗадачиКВыполнению);
	ЗадачиАссистента.Сбросить();
	
	ЗапланироватьЗадачиПодтверждения(ПредметОбъект, ИнтервалЗаписи, ЗадачиАссистента, НовыеТекущиеЗадачиКВыполнению);
	
КонецПроцедуры

Функция ЗаказПокупателяПодходитУсловиямЗадачи(ЗадачаАссистента, ПредметОбъект)
	
	Если ЗадачаАссистента.ДляВидаЗаказНаряда <> ПредметОбъект.ВидЗаказа Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если (ЗадачаАссистента.Идентификатор = ИдентификаторЗадачаПодтверждениеЗаписи()
		ИЛИ ЗадачаАссистента.Идентификатор = ИдентификаторЗадачаНапоминаниеОЗаписи()
		ИЛИ ЗадачаАссистента.Идентификатор = ИдентификаторЗадачаПроведениеОпросаПослеЗаписи())
		И ПредметОбъект.ВариантЗавершения = Перечисления.ВариантыЗавершенияЗаказа.Отменен Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ЗадачаАссистента.Идентификатор = ИдентификаторЗадачаПодтверждениеОтменыЗаписи()
		И ПредметОбъект.ВариантЗавершения <> Перечисления.ВариантыЗавершенияЗаказа.Отменен Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ЗадачаАссистента.ОтборСостояниеПредмета)
		И ЗадачаАссистента.ОтборСостояниеПредмета <> ПредметОбъект.СостояниеЗаказа Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ ПредметОбъект.Проведен Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Функция ИзменилосьСостояниеЗаказа(ПредметОбъект)
	
	Возврат ПредметОбъект.СостояниеЗаказа <> ПредметОбъект.ДополнительныеСвойства.ЗадачиАссистента.ДанныеДоЗаписи.СостояниеЗаказа
		ИЛИ ПредметОбъект.ВариантЗавершения <> ПредметОбъект.ДополнительныеСвойства.ЗадачиАссистента.ДанныеДоЗаписи.ВариантЗавершения;
	
КонецФункции

Функция ИзменилосьПроведениеЗаказа(ПредметОбъект)
	
	Возврат ПредметОбъект.Проведен И НЕ ПредметОбъект.ДополнительныеСвойства.ЗадачиАссистента.Проведен;
	
КонецФункции

Функция ИзменилсяВидЗаказа(ПредметОбъект)
	
	Возврат ПредметОбъект.ВидЗаказа <> ПредметОбъект.ДополнительныеСвойства.ЗадачиАссистента.ДанныеДоЗаписи.ВидЗаказа;
	
КонецФункции

#КонецОбласти

#Область ОбработкаСобытияЗапись

Процедура ПередЗаписьюСобытиеЗапись(ПредметОбъект)
	
	Если ТипЗнч(ПредметОбъект) <> Тип("ДокументОбъект.Событие") Тогда
		Возврат;
	КонецЕсли;
	
	Если ПредметОбъект.ТипСобытия <> Перечисления.ТипыСобытий.Запись Тогда
		Возврат;
	КонецЕсли;
	
	РеквизитыСобытия = "ПометкаУдаления,Состояние,РесурсыПредприятия";
	ДанныеСсылки = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ПредметОбъект.Ссылка, РеквизитыСобытия);
	
	ПредметОбъект.ДополнительныеСвойства.ЗадачиАссистента.Вставить("ДанныеДоЗаписи", ДанныеСсылки);
	
КонецПроцедуры

Процедура ПриЗаписиДокументаСобытиеЗапись(ПредметОбъект, НовыеТекущиеЗадачиКВыполнению, НовыеРегулярныеЗадачиКВыполнению)
	
	Если ТипЗнч(ПредметОбъект) <> Тип("ДокументОбъект.Событие") Тогда
		Возврат;
	КонецЕсли;
	
	Если ПредметОбъект.ТипСобытия <> Перечисления.ТипыСобытий.Запись Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЕстьИзмененияПоПредмету(ПредметОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ЗадачиАссистента = ВыборкаЗадачКВыполнению();
	УдалитьЗапланированныеЗадачиПоПредмету(ПредметОбъект.Ссылка, ЗадачиАссистента);
	ЗадачиАссистента.Сбросить();
	
	Если ПредметОбъект.ПометкаУдаления Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаДвиженийРесурсы = Неопределено;
	ПредметОбъект.ДополнительныеСвойства.Свойство("ТаблицаДвиженийРесурсы", ТаблицаДвиженийРесурсы);
	
	Если ТаблицаДвиженийРесурсы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИнтервалЗаписи = ПланированиеРесурсовУНФ.МаксимальныеГраницыИнтервала(ТаблицаДвиженийРесурсы, "Старт", "Финиш");
	
	ЗапланироватьЗадачиНапоминанияОЗаписи(ПредметОбъект, ТаблицаДвиженийРесурсы, ЗадачиАссистента, НовыеРегулярныеЗадачиКВыполнению);
	ЗадачиАссистента.Сбросить();
	
	ЗапланироватьЗадачиОпросаПослеЗаписи(ПредметОбъект, ИнтервалЗаписи, ЗадачиАссистента, НовыеРегулярныеЗадачиКВыполнению);
	ЗадачиАссистента.Сбросить();
	
	ЗапланироватьЗадачиПодтверждения(ПредметОбъект, ИнтервалЗаписи, ЗадачиАссистента, НовыеТекущиеЗадачиКВыполнению);
	
КонецПроцедуры

Функция СобытиеПодходитУсловиямЗадачи(ЗадачаАссистента, ПредметОбъект)
	
	Если НЕ ЗадачаАссистента.ДляДокументаСобытие Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если (ЗадачаАссистента.Идентификатор = ИдентификаторЗадачаНапоминаниеОЗаписи()
		ИЛИ ЗадачаАссистента.Идентификатор = ИдентификаторЗадачаПроведениеОпросаПослеЗаписи())
		И ПредметОбъект.Состояние = ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.СостоянияСобытий.Отменено") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ЗадачаАссистента.ОтборСостояниеПредмета)
		И ЗадачаАссистента.ОтборСостояниеПредмета <> ПредметОбъект.Состояние Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Функция ИзменилосьСостояниеСобытия(ПредметОбъект)
	
	Возврат ПредметОбъект.Состояние <> ПредметОбъект.ДополнительныеСвойства.ЗадачиАссистента.ДанныеДоЗаписи.Состояние;
	
КонецФункции

#КонецОбласти

#Область ОтменаЗаписи

Функция НазначенияШаблоновСКнопкойОтменаЗаписи()
	
	ОжидаемыеНазначения = Новый Массив;
	ОжидаемыеНазначения.Добавить("Документ.ЗаказПокупателя");
	ОжидаемыеНазначения.Добавить("Документ.Событие");
	Возврат ОжидаемыеНазначения;
	
КонецФункции

Функция ЭтоВходящееПисьмо(ПредметОбъект)
	
	Если ТипЗнч(ПредметОбъект) <> Тип("ДокументОбъект.Событие") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ПредметОбъект.ТипСобытия <> Перечисления.ТипыСобытий.ЭлектронноеПисьмо Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат ПредметОбъект.ВходящееИсходящееСобытие = Перечисления.ВходящееИсходящееСобытие.Входящее;
	
КонецФункции

Функция ТемаПисьмаОтменаСобытиеЗапись()
	
	Возврат НСтр("ru='[Auto] Отмена записи'");
	
КонецФункции

Функция ТемаПисьмаОтменаЗаказНарядЗапись()
	
	Возврат НСтр("ru='[Auto] Отмена заказа'");
	
КонецФункции

Функция НовыйТемаПисьмаОтменаЗаписьПоПредмету(НазначениеШаблона, ПредметСообщения)
	
	НомерДокумента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПредметСообщения, "Номер");
	Если НазначениеШаблона = "Документ.ЗаказПокупателя" Тогда
		ТемаПисьма = ТемаПисьмаОтменаЗаказНарядЗапись() + " " + НомерДокумента;
	ИначеЕсли НазначениеШаблона = "Документ.Событие" Тогда
		ТемаПисьма = ТемаПисьмаОтменаСобытиеЗапись() + " " + НомерДокумента;
	Иначе
		ТекстОшибки = СтрШаблон(
			НСтр("ru='Не определена тема письма отмены записи для назначения ""%1""'"),
			НазначениеШаблона);
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	Возврат ТемаПисьма;
	
КонецФункции

Функция ТелоПисьмаОтменаЗапись()
	
	Возврат НСтр("ru='При отправке сообщения запись будет автоматически отменена.'");
	
КонецФункции

Функция КартинкаКнопкаОтменитьЗаписьПоУмолчанию()
	
	Возврат БиблиотекаКартинок.КнопкаОтменитьЗапись.ПолучитьДвоичныеДанные();
	
КонецФункции

Функция АдресЭлектроннойПочтыДляОтменыЗаписи()
	
	ИдентификаторыЗадач = Новый Массив;
	ИдентификаторыЗадач.Добавить(ИдентификаторЗадачаНапоминаниеОЗаписи());
	ИдентификаторыЗадач.Добавить(ИдентификаторЗадачаПодтверждениеЗаписи());
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЗадачиАссистентаПоНапоминаниямОЗаписи.УчетнаяЗапись КАК УчетнаяЗапись
	|ИЗ
	|	Справочник.ЗадачиАссистентаПоНапоминаниямОЗаписи КАК ЗадачиАссистентаПоНапоминаниямОЗаписи
	|ГДЕ
	|	ЗадачиАссистентаПоНапоминаниямОЗаписи.Идентификатор В(&ИдентификаторыЗадач)";
	Запрос.УстановитьПараметр("ИдентификаторыЗадач", ИдентификаторыЗадач);
	
	Результат = Запрос.Выполнить().Выбрать();
	
	Если Результат.Следующий() Тогда
		Возврат Результат.УчетнаяЗапись;
	КонецЕсли;
	
	ТекстОшибки = СтрШаблон(
		НСтр("ru='Не указана учетная запись для задач по уведомлениям: %1'"),
		СтрСоединить(ИдентификаторыЗадач, ", "));
	ВызватьИсключение ТекстОшибки;
	
КонецФункции

Функция ДокументЗаписьДляАвтоматическойОтменыИзПисьма(ПредметОбъект)
	
	ДатаИнтервалаПоискаНомера = НачалоГода(ТекущаяДатаСеанса());
	
	Если СтрНачинаетсяС(ПредметОбъект.Тема, ТемаПисьмаОтменаЗаказНарядЗапись()) Тогда
		НомерДокумента = СтрЗаменить(ПредметОбъект.Тема, ТемаПисьмаОтменаЗаказНарядЗапись(), "");
		МенеджерДокумента = Документы.ЗаказПокупателя;
	ИначеЕсли СтрНачинаетсяС(ПредметОбъект.Тема, ТемаПисьмаОтменаСобытиеЗапись()) Тогда
		НомерДокумента = СтрЗаменить(ПредметОбъект.Тема, ТемаПисьмаОтменаСобытиеЗапись(), "");
		МенеджерДокумента = Документы.Событие;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
	НомерДокумента = СокрЛП(НомерДокумента);
	Возврат МенеджерДокумента.НайтиПоНомеру(НомерДокумента, ДатаИнтервалаПоискаНомера);
	
КонецФункции

Процедура ПриЗаписиДокументаСобытиеПисьмо(ПредметОбъект)
	
	Если НЕ ЭтоВходящееПисьмо(ПредметОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ПредметОбъект.ДополнительныеСвойства.ЗадачиАссистента.ЭтоНовый Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	НайденнаяЗаписьДляОтмены = ДокументЗаписьДляАвтоматическойОтменыИзПисьма(ПредметОбъект);
	
	Если НайденнаяЗаписьДляОтмены = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(НайденнаяЗаписьДляОтмены) = Тип("ДокументСсылка.ЗаказПокупателя") Тогда
		ОтменитьЗаписьДокументЗаказНаряд(НайденнаяЗаписьДляОтмены, ПредметОбъект.Ссылка);
	ИначеЕсли ТипЗнч(НайденнаяЗаписьДляОтмены) = Тип("ДокументСсылка.Событие") Тогда
		ОтменитьЗаписьДокументСобытие(НайденнаяЗаписьДляОтмены, ПредметОбъект.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОтменитьЗаписьДокументСобытие(Событие, ПисьмоОснование)
	
	ЗаказОтмененУспешно = Истина;
	
	Попытка
		СобытиеОбъект = Событие.ПолучитьОбъект();
		СобытиеОбъект.Заблокировать();
		СобытиеОбъект.Состояние = ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.СостоянияСобытий.Отменено");
		СобытиеОбъект.Записать();
	Исключение
		ЗаказОтмененУспешно = Ложь;
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ЗаписьЖурналаРегистрации(
			АссистентУправления.ИмяСобытияЖР(), УровеньЖурналаРегистрации.Ошибка,,
			Событие, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
	КонецПопытки;
	
	Если ЗаказОтмененУспешно Тогда
		ДанныеСообщения = ОбсужденияУНФ.НовыйДанныеСообщения();
		ДанныеСообщения.Объект = Событие;
		ДанныеСообщения.Текст = СтрШаблон(
			НСтр("ru='Отменила запись по просьбе покупателя
			|%1'"),
			ПолучитьНавигационнуюСсылку(ПисьмоОснование));
		ДанныеСообщения.Автор = АссистентУправления.ПользовательАссистент();
		ДанныеСообщения.Получатель = АссистентУправления.ПолучитьОтветственного(Событие);
		ОбсужденияУНФ.СоздатьСообщениеОтложенно(ДанныеСообщения);
	Иначе
		ДобавитьСообщениеОбОшибкеОтменыЗаписиВПисьмо(ПисьмоОснование, Событие, КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
	КонецЕсли;
	
КонецПроцедуры

Процедура ОтменитьЗаписьДокументЗаказНаряд(ЗаказПокупателя, ПисьмоОснование)
	
	ЗаказОтмененУспешно = Истина;
	
	Попытка
		ЗаказОбъект = ЗаказПокупателя.ПолучитьОбъект();
		ЗаказОбъект.Заблокировать();
		ЗаказОбъект.СостояниеЗаказа = ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.СостоянияЗаказНарядов.Завершен");
		ЗаказОбъект.ВариантЗавершения = Перечисления.ВариантыЗавершенияЗаказа.Отменен;
		ЗаказОбъект.ПричинаОтмены = Константы.ПричинаАвтоматическойОтменыЗаказаИзПисьма.Получить();
		ЗаказОбъект.Записать();
	Исключение
		ЗаказОтмененУспешно = Ложь;
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ЗаписьЖурналаРегистрации(
			АссистентУправления.ИмяСобытияЖР(), УровеньЖурналаРегистрации.Ошибка,,
			ЗаказПокупателя, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
	КонецПопытки;
	
	Если ЗаказОтмененУспешно Тогда
		ДанныеСообщения = ОбсужденияУНФ.НовыйДанныеСообщения();
		ДанныеСообщения.Объект = ЗаказПокупателя;
		ДанныеСообщения.Текст = СтрШаблон(
			НСтр("ru='Отменила запись по запросу клиента
			|%1'"),
			ПолучитьНавигационнуюСсылку(ПисьмоОснование));
		ДанныеСообщения.Автор = АссистентУправления.ПользовательАссистент();
		ДанныеСообщения.Получатель = АссистентУправления.ПолучитьОтветственного(ЗаказПокупателя);
		ОбсужденияУНФ.СоздатьСообщениеОтложенно(ДанныеСообщения);
	Иначе
		ДобавитьСообщениеОбОшибкеОтменыЗаписиВПисьмо(ПисьмоОснование, ЗаказПокупателя, КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьСообщениеОбОшибкеОтменыЗаписиВПисьмо(Письмо, ЗаписьКлиента, ТекстОшибки)
	
	ТекстСообщения = СтрШаблон(
		НСтр("ru='Нашла запись клиента:
		|%1
		|
		|Но не удалось отменить ее по причине:
		|%2'"),
		ЗаписьКлиента,
		ТекстОшибки);
	
	ДанныеСообщения = ОбсужденияУНФ.НовыйДанныеСообщения();
	ДанныеСообщения.Объект = Письмо;
	ДанныеСообщения.Текст = ТекстСообщения;
	ДанныеСообщения.Автор = АссистентУправления.ПользовательАссистент();
	ДанныеСообщения.Получатель = АссистентУправления.ПолучитьОтветственного(Письмо);
	ОбсужденияУНФ.СоздатьСообщениеОтложенно(ДанныеСообщения);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли