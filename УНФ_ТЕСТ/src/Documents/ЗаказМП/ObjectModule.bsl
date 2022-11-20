#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбщегоНазначения

Процедура ЗаполнитьОтгрузку() Экспорт
	
	Если НЕ Отгружен Тогда
		ОбщегоНазначенияМПСервер.УдалитьСвязанныеДокументы("РасходТовараМП", Ссылка);
		Возврат;
	КонецЕсли;
	
	НайденнаяСсылка = Документы.РасходТовараМП.НайтиПоРеквизиту("Основание", Ссылка);
	Если НайденнаяСсылка.Пустая() Тогда
		РасходОбъект = Документы.РасходТовараМП.СоздатьДокумент();
		РасходОбъект.Дата = ТекущаяДата();
		РасходОбъект.УстановитьНовыйНомер();
	Иначе
		РасходОбъект = НайденнаяСсылка.ПолучитьОбъект();
	КонецЕсли;
	
	РасходОбъект.СуммаСкидки = СуммаСкидки;
	РасходОбъект.СуммаДокумента = СуммаДокумента;
	РасходОбъект.Покупатель = Покупатель;
	РасходОбъект.Основание = Ссылка;
	
	ТаблицаТоваров = Товары.Выгрузить();
	РасходОбъект.Товары.Загрузить(ТаблицаТоваров);
	
	Если ОбменДанными.Загрузка Тогда
		РасходОбъект.ОбменДанными.Получатели.АвтоЗаполнение = Ложь;
	КонецЕсли;
	
	Если РасходОбъект.ПометкаУдаления<> ПометкаУдаления Тогда
		РасходОбъект.Записать();
		РасходОбъект.УстановитьПометкуУдаления(ПометкаУдаления);
	КонецЕсли;
	
	Если Проведен Тогда
		РасходОбъект.Записать(РежимЗаписиДокумента.Проведение);
	ИначеЕсли РасходОбъект.Проведен Тогда
		РасходОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
	Иначе
		РасходОбъект.Записать();
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьОплату() Экспорт
	
	Если ДополнительныеСвойства.Свойство("ПринудительноСформироватьДокументОплаты") Тогда
	Иначе
		Если СуммаОплаты = 0 Тогда
			ОбщегоНазначенияМПСервер.УдалитьСвязанныеДокументы("ПриходДенегМП", Ссылка);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	НайденнаяСсылка = Документы.ПриходДенегМП.НайтиПоРеквизиту("Основание", Ссылка);
	Если НайденнаяСсылка.Пустая() Тогда
		ОплатаОбъект = Документы.ПриходДенегМП.СоздатьДокумент();
		ОплатаОбъект.Дата = ТекущаяДата();
		ОплатаОбъект.УстановитьНовыйНомер();
	Иначе
		ОплатаОбъект = НайденнаяСсылка.ПолучитьОбъект();
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ОплатаОбъект.Статья)
		И ОбщегоНазначенияМПСервер.ЕстьПредопределенныйВДанных("СтатьиМП", "ОплатаОтПокупателя") Тогда
		ОплатаОбъект.Статья = Справочники.СтатьиМП.ОплатаОтПокупателя;
	КонецЕсли;
	ОплатаОбъект.Сумма = СуммаОплаты;
	ОплатаОбъект.Контрагент = Покупатель;
	ОплатаОбъект.Основание = Ссылка;
	
	Если ОбменДанными.Загрузка Тогда
		ОплатаОбъект.ОбменДанными.Получатели.АвтоЗаполнение = Ложь;
	КонецЕсли;
	
	Если ОплатаОбъект.ПометкаУдаления <> ПометкаУдаления Тогда
		ОплатаОбъект.Записать();
		ОплатаОбъект.УстановитьПометкуУдаления(ПометкаУдаления);
	КонецЕсли;
	
	Если Проведен Тогда
		ОплатаОбъект.Записать(РежимЗаписиДокумента.Проведение);
	ИначеЕсли ОплатаОбъект.Проведен Тогда
		ОплатаОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
	Иначе
		ОплатаОбъект.Записать();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ПометкаУдаления Тогда
		РежимЗаписи = РежимЗаписиДокумента.Проведение;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("ЗапретитьОперацииСоСвязанымиДокументами")
		И ДополнительныеСвойства.ЗапретитьОперацииСоСвязанымиДокументами Тогда
	ИначеЕсли НЕ Ссылка.Пустая() Тогда
		НайденнаяСсылка = Документы.РасходТовараМП.НайтиПоРеквизиту("Основание", Ссылка);
		Если НЕ НайденнаяСсылка.Пустая() Тогда
			РасходОбъект = НайденнаяСсылка.ПолучитьОбъект();
			РасходОбъект.ДополнительныеСвойства.Вставить("ЗапретитьОперацииСоСвязанымиДокументами", Истина);
			РасходОбъект.ДополнительныеСвойства.Вставить("ЗапретитьПовторныйЗапускОбмена", Истина);
			РасходОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
		КонецЕсли;
	КонецЕсли;
	
	СуммаДокумента = Товары.Итог("Сумма") - СуммаСкидки;
	
	Если Отгружен 
		И НЕ ОтгруженУстановленВЦентральнойБазе
		И РежимЗаписи = РежимЗаписиДокумента.Проведение
		И НЕ Константы.НеКотролироватьОстаткиМП.Получить() Тогда
		
		Остатки = РегистрыНакопления.ОстаткиТоваровМП.Остатки();
		
		НайденнаяСсылка = Документы.РасходТовараМП.НайтиПоРеквизиту("Основание", Ссылка);
		ДвиженияПоОтгрузке = РегистрыНакопления.ОстаткиТоваровМП.ВыбратьПоРегистратору(НайденнаяСсылка);
		
		Для каждого СтрокаЗаказа Из Товары Цикл
			
			Если СтрокаЗаказа.Товар.Вид = Перечисления.ВидыТоваровМП.Товар Тогда
				
				НайденнаяСтрокаОстатков = Остатки.Найти(СтрокаЗаказа.Товар, "Товар");
				Если НайденнаяСтрокаОстатков = Неопределено Тогда
					КоличествоНаСкладе = 0;
				Иначе
					КоличествоНаСкладе = НайденнаяСтрокаОстатков.Количество;
				КонецЕсли;
				
				Пока ДвиженияПоОтгрузке.Следующий() Цикл
					Если СтрокаЗаказа.Товар = ДвиженияПоОтгрузке.Товар Тогда
						КоличествоНаСкладе = КоличествоНаСкладе + ?(ДвиженияПоОтгрузке.ВидДвижения = ВидДвиженияНакопления.Расход, 1, -1) * ДвиженияПоОтгрузке.Количество;
					КонецЕсли;
				КонецЦикла;
				
				Если КоличествоНаСкладе < СтрокаЗаказа.Количество
					И НЕ ДополнительныеСвойства.Свойство("НеКонтролироватьОстатки") Тогда
					СтрокаОшибки = НСтр("ru='На складе нет достаточного количества остатков товара:"
					"%Товар%. Не хватает %Количество%';en='In stock do not have enough residual item:"
					"%Товар%. Not enough %Количество%'");
					СтрокаОшибки = СтрЗаменить(СтрокаОшибки, "%Товар%", СокрЛП(СтрокаЗаказа.Товар));
					СтрокаОшибки = СтрЗаменить(СтрокаОшибки, "%Количество%", СокрЛП(СтрокаЗаказа.Количество - КоличествоНаСкладе));
					ОбщегоНазначенияМПКлиентСервер.СообщитьПользователю(СтрокаОшибки, , Отказ);
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если Отгружен И Оплачен Тогда
		СостояниеЗаказа = Перечисления.СостоянияЗаказовМП.Выполнен;
	Иначе
		СостояниеЗаказа = Перечисления.СостоянияЗаказовМП.ВРаботе;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	//МассивУзловДляРегистрации = Новый Массив;
	//
	//Выборка = ПланыОбмена.МобильноеПриложение.Выбрать();
	//Пока Выборка.Следующий() Цикл
	//	Если Выборка.Ссылка <> ПланыОбмена.МобильноеПриложение.ЭтотУзел() Тогда
	//		//Если НЕ ИзЦентральнойБазы Тогда
	//			МассивУзловДляРегистрации.Добавить(Выборка.Ссылка);
	//		//КонецЕсли;
	//	КонецЕсли;
	//КонецЦикла;
	//
	//Если МассивУзловДляРегистрации.Количество() > 0 Тогда
	//	ПланыОбмена.ЗарегистрироватьИзменения(МассивУзловДляРегистрации, Ссылка);
	//КонецЕсли;
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("ЗапретитьОперацииСоСвязанымиДокументами")
		И ДополнительныеСвойства.ЗапретитьОперацииСоСвязанымиДокументами Тогда
	Иначе
		ЗаполнитьОтгрузку();
		ЗаполнитьОплату();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Отгружен = Ложь;
	Оплачен = Ложь;
	ИзЦентральнойБазы = Ложь;
	ОтгруженУстановленВЦентральнойБазе = Ложь;
	ОплаченУстановленВЦентральнойБазе = Ложь;
	Комментарий = "";
	СуммаОплаты = 0;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли